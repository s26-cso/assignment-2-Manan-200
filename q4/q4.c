#include <stdio.h>
#include <dlfcn.h>

int main(){
    char op[6]; // operation name
    int num1, num2;

    while (scanf("%s %d %d", op, &num1, &num2) == 3) { // read until EOF
        char libname[20];

        sprintf(libname, "./lib%s.so", op); // build library name (eg: libadd.so)

        void *handle = dlopen(libname, RTLD_LAZY); // load library at runtime

        int (*func)(int, int) = dlsym(handle, op); // get func ptr

        int result = func(num1, num2);

        printf("%d\n", result);

        dlclose(handle); // unload
    }
    return 0;
}