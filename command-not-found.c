//gcc -O2 command-not-found.c -o command-not-found

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>
#include <limits.h>
#include <stdbool.h>
#include <ctype.h>

#define MAX_MATCHES 5
#define MAX_DISTANCE 3

typedef struct {
    char *name;
    int distance;
} Match;

typedef struct {
    Match matches[MAX_MATCHES];
    int count;
} Matches;

// Add support for special commands
typedef struct {
    const char *cmd;
    const char **subcommands;
    int subcommand_count;
} SpecialCommand;

// Common subcommands for special handling
static const char *SYSTEMCTL_COMMANDS[] = {
    "enable", "disable", "start", "stop", "restart",
    "status", "reload", "mask", "unmask"
};

static const char *GIT_COMMANDS[] = {
    "add", "commit", "push", "pull", "fetch", "merge",
    "rebase", "status", "log", "diff", "branch", "checkout"
};

static const SpecialCommand SPECIAL_COMMANDS[] = {
    {"systemctl", SYSTEMCTL_COMMANDS, sizeof(SYSTEMCTL_COMMANDS)/sizeof(char*)},
    {"git", GIT_COMMANDS, sizeof(GIT_COMMANDS)/sizeof(char*)}
};

static int transposition_distance(const char *s1, const char *s2) {
    int len1 = strlen(s1);
    int len2 = strlen(s2);
    
    if (len1 != len2) return INT_MAX;
    
    if (len1 == 2 && s1[0] == s2[1] && s1[1] == s2[0])
        return 1;
        
    int swaps = 0;
    char *sorted1 = strdup(s1);
    char *sorted2 = strdup(s2);
    
    qsort(sorted1, len1, 1, (int(*)(const void*,const void*))strcmp);
    qsort(sorted2, len2, 1, (int(*)(const void*,const void*))strcmp);
    
    if (strcmp(sorted1, sorted2) == 0) {
        for (int i = 0; i < len1; i++) {
            if (s1[i] != s2[i]) swaps++;
        }
        swaps /= 2;
    } else {
        swaps = INT_MAX;
    }
    
    free(sorted1);
    free(sorted2);
    
    return swaps;
}

static int levenshtein(const char *s1, const char *s2, int max_distance) {
    int len1 = strlen(s1);
    int len2 = strlen(s2);
    
    if (abs(len1 - len2) > max_distance) {
        return INT_MAX;
    }

    int *matrix = malloc((len1 + 1) * (len2 + 1) * sizeof(int));
    if (!matrix) return INT_MAX;

    for (int i = 0; i <= len1; i++) matrix[i * (len2 + 1)] = i;
    for (int j = 0; j <= len2; j++) matrix[j] = j;

    for (int i = 1; i <= len1; i++) {
        bool row_under_max = false;
        for (int j = 1; j <= len2; j++) {
            int cost = (tolower(s1[i-1]) == tolower(s2[j-1])) ? 0 : 1;
            
            int above = matrix[(i-1) * (len2 + 1) + j] + 1;
            int left = matrix[i * (len2 + 1) + j-1] + 1;
            int diag = matrix[(i-1) * (len2 + 1) + j-1] + cost;
            
            int min = above < left ? above : left;
            min = min < diag ? min : diag;
            
            matrix[i * (len2 + 1) + j] = min;
            
            if (min <= max_distance) row_under_max = true;
        }
        if (!row_under_max) {
            free(matrix);
            return INT_MAX;
        }
    }

    int result = matrix[len1 * (len2 + 1) + len2];
    free(matrix);
    return result;
}

static void insert_match(Matches *matches, const char *name, int distance) {
    int pos = matches->count;
    while (pos > 0 && matches->matches[pos-1].distance > distance) {
        if (pos < MAX_MATCHES) {
            matches->matches[pos] = matches->matches[pos-1];
        }
        pos--;
    }
    
    if (pos < MAX_MATCHES) {
        matches->matches[pos].name = strdup(name);
        matches->matches[pos].distance = distance;
        if (matches->count < MAX_MATCHES) matches->count++;
    }
}

static void find_similar_commands(const char *cmd, Matches *matches) {
    char *path = strdup(getenv("PATH"));
    char *dir = strtok(path, ":");
    
    while (dir) {
        DIR *d = opendir(dir);
        if (d) {
            struct dirent *ent;
            while ((ent = readdir(d))) {
                if (ent->d_type == DT_REG || ent->d_type == DT_LNK) {
                    char full_path[PATH_MAX];
                    snprintf(full_path, sizeof(full_path), "%s/%s", dir, ent->d_name);
                    
                    if (access(full_path, X_OK) == 0) {
                        int lev_dist = levenshtein(cmd, ent->d_name, MAX_DISTANCE);
                        int trans_dist = transposition_distance(cmd, ent->d_name);
                        int dist = lev_dist < trans_dist ? lev_dist : trans_dist;
                        
                        if (dist <= MAX_DISTANCE) {
                            insert_match(matches, ent->d_name, dist);
                        }
                    }
                }
            }
            closedir(d);
        }
        dir = strtok(NULL, ":");
    }
    
    free(path);
}

static bool check_special_command(const char *cmd, const char *subcmd) {
    for (size_t i = 0; i < sizeof(SPECIAL_COMMANDS)/sizeof(SpecialCommand); i++) {
        if (strcmp(cmd, SPECIAL_COMMANDS[i].cmd) == 0) {
            Matches matches = {0};
            
            for (int j = 0; j < SPECIAL_COMMANDS[i].subcommand_count; j++) {
                int lev_dist = levenshtein(subcmd, SPECIAL_COMMANDS[i].subcommands[j], MAX_DISTANCE);
                if (lev_dist <= MAX_DISTANCE) {
                    insert_match(&matches, SPECIAL_COMMANDS[i].subcommands[j], lev_dist);
                }
            }
            
            if (matches.count > 0) {
                printf("Unknown command verb '%s', did you mean '%s'?\n", 
                       subcmd, matches.matches[0].name);
                for (int k = 0; k < matches.count; k++) {
                    free(matches.matches[k].name);
                }
                return true;
            }
        }
    }
    return false;
}

int main(int argc, char *argv[]) {
    if (argc < 2) return 1;
    
    // Check for special commands first
    if (argc > 2) {
        if (check_special_command(argv[1], argv[2])) {
            return 127;
        }
    }
    
    // Handle regular command suggestions
    Matches matches = {0};
    find_similar_commands(argv[1], &matches);
    
    if (matches.count > 0) {
        printf("NOTFOUND:%s\n", argv[1]);
        for (int i = 0; i < matches.count; i++) {
            printf("SUGGESTION:%d:%s\n", i + 1, matches.matches[i].name);
            free(matches.matches[i].name);
        }
    } else {
        printf("NOTFOUND:%s\n", argv[1]);
    }
    
    return 127;
}