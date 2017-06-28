### cJSON

项目中加入cJSON.h、cJSON.c，用make编译即可

```shell
gcc cJSON.c main.c -o main -lm
// 添加-lm是因为用到了数学库函数
```

**cJSON结点** 

```c
#define cJSON_False 0
#define cJSON_True 1
#define cJSON_NULL 2
#define cJSON_Number 3
#define cJSON_String 4
#define cJSON_Array 5
#define cJSON_Object 6

typedef struct cJSON {
    struct cJSON *next,*prev;    /* next/prev allow you to walk array/object chains. Alternatively, use GetArraySize/GetArrayItem/GetObjectItem */
    struct cJSON *child;        /* An array or object item will have a child pointer pointing to a chain of the items in the array/object. */

    int type;                    /* The type of the item, as above. cjson结构的类型上面宏定义的7中之一*/

    char *valuestring;            /* The item's string, if type==cJSON_String */
    int valueint;                /* The item's number, if type==cJSON_Number */
    double valuedouble;            /* The item's number, if type==cJSON_Number */

    char *string;                /* The item's name string, if this item is the child of, or is in the list of subitems of an object. */
} cJSON;
```

 

[cJSON 使用详解](https://my.oschina.net/u/2255341/blog/543508)

