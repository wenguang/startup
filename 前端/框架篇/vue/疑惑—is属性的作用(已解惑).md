## 疑惑—is属性的作用

[一个组件的v-for](https://cn.vuejs.org/v2/guide/list.html#一个组件的-v-for) 

* is="todo-item" 有什么作用？
* html中的li部分与组件模板中的html是否重复？

```html
<body>
    <div id="example">
        <input v-model="newTodoText" v-on:keyup.enter="addNewTodo" placeholder="Add a todo">
        <ul>
            <li is="todo-item" v-for="(todo, index) of todos" :key="todo.id" :title="todo.title" v-on:remove="todos.splice(index, 1)">
                {{todo.title}}</li>
        </ul>
    </div>
    <script type="text/javascript">
    Vue.component('todo-item', {
        template: '\
    			<li>{{title}}\
    			<button v-on:click="$emit(\'remove\')">X</button>\
    			</li>',
        props: ['title']
    });
    var example = new Vue({
        el: '#example',
        data: {
            newTodoText: '',
            todos: [
                { id: 1, title: 'do the dishes' },
                { id: 2, title: 'take out the trash' },
                { id: 3, title: 'mow the lawn' }
            ],
            nextTodoId: 4
        },
        methods: {
            addNewTodo: function() {
                this.todos.push({
                    id: this.nextTodoId++,
                    title: this.newTodoText
                });
            }
        }
    });
    </script>
</body>
```



