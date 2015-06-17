#include <stdio.h>

__global__ void add(int *a, int *b, int *c) {
	c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}

#define N 16

void check(cudaError_t err) {
	if (err != cudaSuccess)
		printf("The error is %s.\n", cudaGetErrorString(err));
}
		
void print_array(int *arr, int len) {
	for (int row = 0; row < 16; row++) {
		for (int i = 0; i < len; i++)
			printf("%d  ", arr[i]);
		printf("\n");
	}
}

void random_ints(int *a, int n) {
	int i;
	for (i = 0; i < n; i++)
		a[i] = (int)(rand() / (RAND_MAX / 1.5));
}


int main(void) {
	int *a, *b, *c;              // host copies of a, b, c
	int *d_a, *d_b, *d_c;        // device copies of a, b, c
	int size = N * sizeof(int);


	// Allocate space for device copies of a, b, c
	check((cudaError_t)cudaMalloc((void **)&d_a, size));
	check((cudaError_t)cudaMalloc((void **)&d_b, size));
	check((cudaError_t)cudaMalloc((void **)&d_c, size));

	// Allocate space for host copies of a, b, c and setup input values
	a = (int*)malloc(size); random_ints(a, N);
	b = (int*)malloc(size); random_ints(b, N);
	c = (int*)malloc(size);

	// Copy inputs to device
	check((cudaError_t)cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice));
	check((cudaError_t)cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice));

	// Launch all() kernel on GPU
	add<<<N,1>>>(d_a, d_b, d_c);

	// Copy result back to host
	check((cudaError_t)cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost));

	// Print results
	printf("Array a:\n");
	print_array(a, N);
	printf("Array b:\n");
	print_array(b, N);
	printf("Sum of a and b:\n");
	print_array(c, N);

	// Cleanup
	free(a); free(b); free(c);
	cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
	
	return 0;
}

