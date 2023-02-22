---
title: "Javascript notes"
date: 2023-02-21T11:54:41+02:00
draft: true
tags: [js, notes]
Categories: [IT]
---

Как заставить выполниться промис
------------------------------------

Предположим, есть функция

```js
async getBooks(authorId) {
    const books = await bookModel.fetchAll();
}
```

Если далее выполнить `console.log(getBookCount(1))` то мы в консоле увидим Promise. Чтобы разрешить этот промис
и получить ответ мы должны выполнить так

```js
getBooks(id).then(data => console.log(data)); // 1-й вариант

console.log(await getBooks(id)); // 2-й вариант

async Function().then(console.log);
```

#### Кратко 
Метод then() используют, чтобы выполнить код после изменения состояния промиса.

Метод принимает два аргумента:

onFulfill — функция-колбэк, которая будет вызвана при переходе промиса в состояние «успех» fulfilled. Функция имеет один параметр, в который передаётся результат выполнения операции
onReject — функция-колбэк, которая будет вызвана при переходе промиса в состояние «ошибка» rejected. Функция имеет один параметр, в который передаётся информация об ошибке
Всегда возвращает новый промис.

```js
// getPasswords() — асинхронная функция, которая возвращает промис
getPasswords().then(
  function (result) {
    // что-то делаем с результатом операции
    console.log('Все пароли:' + result)
  },
  function (err) {
    // обрабатываем ошибку
    console.error(err.message)
  }
)
```

но обычно вместо второй функции используют catch:

```js
getPasswords()
  .then(function (result) {
    console.log(`Все пароли: ${result}`)
  })
  .catch(function (error) {
      console.log(`Ошибка: ${error.message}`)
  })
```