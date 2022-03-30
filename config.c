#include "config.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

char *data_dir = "";

int find_data_dir() 
{
	struct stat sb;
	const char *home_dir = getenv("HOME");
	const char *suffix = "/.local/share/mario";
	char *full_dir = malloc(strlen(home_dir) + strlen(suffix) + 1);
	sprintf(full_dir, "%s%s", home_dir, suffix);

	if (stat(full_dir, &sb) == 0) {
		data_dir = full_dir;
		return 1;
	}
	else if (stat("/usr/share/mario", &sb) == 0) {
		data_dir = "/usr/share/mario";
		return 1;
	}
	return 0;
}
