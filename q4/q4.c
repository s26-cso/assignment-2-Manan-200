#include <stdio.h>
#include <dlfcn.h>

int main(){
    char op[6];
    int num1, num2;

    while (scanf("%s %d %d", op, &num1, &num2) == 3) {
        char libname[20];

        sprintf(libname, "./lib%s.so", op);

        void *handle = dlopen(libname, RTLD_LAZY);

        int (*func)(int, int) = dlsym(handle, op);

        int result = func(num1, num2);

        printf("%d\n", result);

        dlclose(handle);
    }
    return 0;
}