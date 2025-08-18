#include "ring_buffer.h"

int main(void) {
    RingBuffer rb;
    rb_init(&rb);

    rb_pushf(&rb, 6,  "I\t%d\t%d\t0", 6, 6);
    rb_pushf(&rb, 7,  "L\t%d\t0\t120005800:lda r17,24(r30)", 7);
    rb_push_raw(&rb, 8, "S\t6\t0\tIF");
    rb_push_raw(&rb, 9, "L\t6\t1\ti-cache-miss");

    /* Dump last 3 lines around a miss, for example */
    fprintf(stdout, "=== PREVIOUS 3 ===\n");
    rb_dump_before(&rb, 3, stdout);

    fprintf(stdout, "=== ALL (oldest→newest) ===\n");
    rb_flush(&rb, stdout);

    return 0;
}

