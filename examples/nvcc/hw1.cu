#include <stdio.h>


int main(void) {
	int deviceCount = 0;
	cudaGetDeviceCount(&deviceCount);
	printf("CUDA devices count is %d.\n", deviceCount);
	return 0;
}
