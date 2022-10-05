#include <vector>
#include "archive.h"

int read_archive(char *filename) {
    struct archive *a = archive_read_new();
    struct archive_entry *e;

    archive_read_support_filter_all(a);
    archive_read_support_format_all(a);

    int r;
    std::vector<uint8_t> data_buffer(getpagesize(), 0);

    r = archive_read_open_filename(a, filename, 10240);
    if (r != ARCHIVE_OK) {
        return 0;
    } 

    while (1) {
        r = archive_read_next_header(a, &e);
        if (r == ARCHIVE_EOF || r == ARCHIVE_FATAL)
            break;
        if (r == ARCHIVE_RETRY)
            continue;

         while (r = archive_read_data(a
                    , data_buffer.data() 
                    , data_buffer.size()) > 0) {
             if (r == ARCHIVE_FATAL) break;
         }
    }
    archive_read_free(a);
    return 0;
}

int main(int argc, char **argv) {
	while (__AFL_LOOP(1000)) {
		read_archive(argv[1]);
	}
}

