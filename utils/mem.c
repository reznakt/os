void memcpy(void *const restrict dst, const void * const restrict src, const int size) {
	for (int i = 0; i < size; i++) {
		((char *) dst)[i] = ((char *) src)[i];
	}
}

int memcmp(const void *const a, const void *const b, const int size) {
	for (int i = 0; i < size; i++) {
		if (((char *) a)[i] < ((char *) b)[i]) {
			return -1;
		} 

		else if (((char *) b)[i] < ((char *) a)[i]) {
			return 1;
		}
	} 

	return 0;
}
