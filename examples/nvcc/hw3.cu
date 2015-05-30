#include <stdio.h>


void check(cudaError_t err) {
	if (err != cudaSuccess)
        	printf("The error is %s.\n", cudaGetErrorString(err));
}

__global__ void add(int *a, int *b, int *c) {
	*c = *a + *b;
}

int main(void) {
	int a, b, c;              // host copies of a, b, c
	int *d_a, *d_b, *d_c;     // device copies of a, b, c
	int size = sizeof(int);

	// Allocate space for device copies of a, b, c
	check((cudaError_t)cudaMalloc((void **)&d_a, size));
	check((cudaError_t)cudaMalloc((void **)&d_b, size));
	check((cudaError_t)cudaMalloc((void **)&d_c, size));

	// Setup input valies
	a = 12;
	b = 7;

	// Copy inputs to device
	check((cudaError_t)cudaMemcpy(d_a, &a, size, cudaMemcpyHostToDevice));
	check((cudaError_t)cudaMemcpy(d_b, &b, size, cudaMemcpyHostToDevice));

	// Launch all() kernel on GPU
	add<<<1,1>>>(d_a, d_b, d_c);

	// Copy result back to host
	check((cudaError_t)cudaMemcpy(&c, d_c, size, cudaMemcpyDeviceToHost));

	printf("%d\n", c);

	// Cleanup
	cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
	
	return 0;
}

