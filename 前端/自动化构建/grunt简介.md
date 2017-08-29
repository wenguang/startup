## Grunt简介

[Grunt 新手一日入门](http://yujiangshui.com/grunt-basic-tutorial/) 

**[Grunt](https://gruntjs.com/) 是任务自动处理器，用来处理一些重复性的工作，如：合并文件、语法检查、Scss编译，文件压缩、文件变动监听...等** 



*Grunt基于Node.js，用npm安装与管理，它已经有很多插件来不同的任务* 

> npm install -g grunt-cli

*实际上，安装的并不是 Grunt，而是 Grunt-cli，也就是命令行的 Grunt，这样你就可以使用 grunt 命令来执行某个项目中的 Gruntfile.js 中定义的 task 。但是要注意，Grunt-cli 只是一个命令行工具，用来执行，而不是 Grunt 这个工具本身。* 



既然是基于Node.js和用npm管理的，那就只需在package.json配置开发依赖为Grunt和各种插件后用npm install安装即可

```json
{
  "name": "gruntxx",
  "version": "0.0.1",
  "description": "学习 grunt",
  "repository": {
    "type": "git",
    "url": "https://github.com/yujiangshui/gruntxx.git"
  },
  "author": "Jiangshui",
  "license": "MIT",
  "bugs": {
    "url": "https://github.com/yujiangshui/gruntxx/issues"
  },
  "homepage": "https://github.com/yujiangshui/gruntxx",
  "devDependencies": {
    "grunt": "^0.4.5",
    "grunt-contrib-concat": "^0.4.0",
    "grunt-contrib-sass": "^0.7.3",
    "grunt-contrib-watch": "^0.6.1",
    "grunt-contrib-jshint": "^0.10.0",
    "grunt-contrib-uglify": "^0.5.0",
    "grunt-contrib-connect": "^0.8.0"
  }
}
```

- 合并文件：[grunt-contrib-concat](https://github.com/gruntjs/grunt-contrib-concat)
- 语法检查：[grunt-contrib-jshint](https://github.com/gruntjs/grunt-contrib-jshint)
- Scss 编译：[grunt-contrib-sass](https://github.com/gruntjs/grunt-contrib-sass)
- 压缩文件：[grunt-contrib-uglify](https://github.com/gruntjs/grunt-contrib-uglify)
- 监听文件变动：[grunt-contrib-watch](https://github.com/gruntjs/grunt-contrib-watch)
- 建立本地服务器：[grunt-contrib-connect](https://github.com/gruntjs/grunt-contrib-connect) 



**配置Gruntfile.js** 

*Gruntfile.js是关键步骤，文件中只要用3块：**任务配置代码**、**插件加载代码**、**任务注册代码**。* 

```javascript
module.exports = function(grunt) {

  var sassStyle = 'expanded';

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    sass: {
      output : {
        options: {
          style: sassStyle
        },
        files: {
          './style.css': './scss/style.scss'
        }
      }
    },
    concat: {
      dist: {
        src: ['./src/plugin.js', './src/plugin2.js'],
        dest: './global.js',
      },
    },
    uglify: {
      compressjs: {
        files: {
          './global.min.js': ['./global.js']
        }
      }
    },
    jshint: {
      all: ['./global.js']
    },
    watch: {
      scripts: {
        files: ['./src/plugin.js','./src/plugin2.js'],
        tasks: ['concat','jshint','uglify']
      },
      sass: {
        files: ['./scss/style.scss'],
        tasks: ['sass']
      },
      livereload: {
          options: {
              livereload: '<%= connect.options.livereload %>'
          },
          files: [
              'index.html',
              'style.css',
              'js/global.min.js'
          ]
      }
    },
    connect: {
      options: {
          port: 9000,
          open: true,
          livereload: 35729,
          // Change this to '0.0.0.0' to access the server from outside
          hostname: 'localhost'
      },
      server: {
        options: {
          port: 9001,
          base: './'
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-connect');

  grunt.registerTask('outputcss',['sass']);
  grunt.registerTask('concatjs',['concat']);
  grunt.registerTask('compressjs',['concat','jshint','uglify']);
  grunt.registerTask('watchit',['sass','concat','jshint','uglify','connect','watch']);
  grunt.registerTask('default');

};
```

