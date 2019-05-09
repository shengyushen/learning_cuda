#include<stdio.h>
#include<cuda_profiler_api.h>


__global__ void VecAdd(float * A, float * B, float * C, int N)
{
	int i= blockDim.x * blockIdx.x+threadIdx.x;
	if(i<N)
		C[i]=A[i]+B[i];
}


int main()
{
	int N=102400;
	size_t size = N*sizeof(float);

	float * xx;

	cudaMalloc(&xx,size);

	float * h_A;
	float * h_B;
	float * h_C;

	cudaMallocManaged(&h_A,size);
	cudaMallocManaged(&h_B,size);
	cudaMallocManaged(&h_C,size);

	for(int i=0;i<N;i++) {
		h_A[i]=i;
		h_B[N-1-i]=i;
	}

/*	for(int i=0;i<N;i++) {
		printf("i %d h_A[i] %f  h_B[i] %f\n",i,h_A[i],h_B[i]);
	}
*
	float * d_A;
	cudaMalloc(&d_A,size);
	float * d_B;
	cudaMalloc(&d_B,size);
	float * d_C;
	cudaMalloc(&d_C,size);
	printf("hh1\n");

	cudaMemcpy(d_A,h_A,size,cudaMemcpyHostToDevice);
	cudaMemcpy(d_B,h_B,size,cudaMemcpyHostToDevice);
*/
	float * d_A=h_A;
	float * d_B=h_B;
	float * d_C=h_C;
	printf("hh2\n");
	int threadsPerBlock = 256;
	int blockPerGrid=(N+threadsPerBlock -1)/threadsPerBlock;

	int repeatTime=102400;
//	cudaProfilerStart();
	for(int i=0;i<repeatTime;i++)	{
		VecAdd<<<blockPerGrid,threadsPerBlock>>> (d_A,d_B,d_C,N);
	}
//	cudaProfilerStop();

	printf("hh3\n");

//	cudaMemcpy(h_C,d_C,size,cudaMemcpyDeviceToHost);
	printf("hh4\n");
	
//	cudaFree(d_A);
//	cudaFree(d_B);
//	cudaFree(d_C);
	printf("hh5\n");
	cudaDeviceSynchronize();
	for(int i=0;i<N & i< 1024;i++) {
		printf("i %d h_C[i] %f\n",i,h_C[i]);
	}
	printf("hh6\n");

	cudaFree(h_A);
	cudaFree(h_B);
	cudaFree(h_C);
}
