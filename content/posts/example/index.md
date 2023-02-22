---
title: "EXAMPLES MD"
date: 2023-02-12T11:54:41+02:00
draft: true
Categories: [IT, Repro]
---

# MD EXAMPLES

![alt](aaa.jpg "{width='100px' height='75' style='border: 3px solid red;'}") 

render must be `style="border: 3px solid red;"`

```
![alternate text](/path-to-image.img "This is the title")
   --------------  ------------------  -----------------
      .Text          .Destination          .Title
```



### Highlighting

```bash
$ sudo apt-get install npm
$ sudo npm intall -g bower
```

```bash {linenos=table,hl_lines=[1],linenostart=199}
$ sudo apt-get install npm
$ sudo npm intall -g bower
```

Adding titles:

{{< path "/src/lib/util.js" >}}
```javascript
function addOne(number) {
    return number + 1;
}
```

Подглючивает нумерация строк - очень узкая колонка.
Можно выделять строки цветом, а так же указывать начальный номер. 

### Картинки

Могут быть в папке images
![](images/bbb.jpg)

или просто рядом с .md
![](aaa.jpg)

