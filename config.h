#ifndef CONFIG_H
#define CONFIG_H

/* Location where assets are installed */
extern char *data_dir;

/* Look for data directory in:
 * ~/.local/share/mario
 * /usr/share/mario
 * Returns 0 on error */
int find_data_dir();

#endif
