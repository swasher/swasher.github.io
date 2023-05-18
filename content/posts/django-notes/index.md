---
Title: Django notes
Date: 2023-05-10T14:00:00+02:00
Category: [IT]
Tags: [pycharm, django]
Author: [Swasher]
---


### Как сделать выделение активных пунктов меню

Create direcroty `templatetags` in any app. In this directore
create file, for example, `active.py`, with following content.
This template tag will be visible in whole project.

```python
import re

from django import template
try:
    from django.urls import reverse, NoReverseMatch
except ImportError:
    from django.core.urlresolvers import reverse, NoReverseMatch

register = template.Library()


@register.simple_tag(takes_context=True)
def active(context, pattern_or_urlname):
    try:
        pattern = '^' + reverse(pattern_or_urlname)
    except NoReverseMatch:
        pattern = pattern_or_urlname
    path = context['request'].path
    if re.search(pattern, path):
        return 'active'
    return ''
```

Then you can use this template tag in following maner:

```html
<li class="nav-item">
    <a class="nav-link {% active 'customers_list' %}" href="{% url 'customers_list' %}"><i class="bi-filetype-pdf me-1"></i>Warehouse</a>
</li>
<li class="nav-item">
    <a class="nav-link {% active 'orders:shablonizator' %}" href="{% url 'orders:shablonizator' %}"><i class="bi-app-indicator me-1"></i>{% trans "Шаблоны" %}</a>
</li>
```
### Как в методе модели `save` сравнить старые и новые значения
[Stackoverflow](https://stackoverflow.com/a/64116052/1334825)

```python
class Detail(models.Model):
    printsheet = models.ForeignKey(PrintSheet, blank=True, null=True, on_delete=models.SET_NULL, related_name='details')

    
    @classmethod
    def from_db(cls, db, field_names, values):
        """
        Helper function. In 'save' method we have _loaded_values attribute, which contain 'old' instance values.
        """
        instance = super().from_db(db, field_names, values)

        # save original values, when model is loaded from database,
        # in a separate attribute on the model
        instance._loaded_values = dict(zip(field_names, values))

        return instance

    def save(self, *args, **kwargs):

        super(Detail, self).save(*args, **kwargs)

        if self._loaded_values['printsheet_id'] != self.printsheet_id:
            """
            Запускаем обновление цветов Листа, только если у Детали изменился связанный Лист.
            Если у Детали поменялся связанный лист с L1 на L2, мы должны обновить оба листа.
            Кроме того, деталь могла быть не связана с листом, или перестать быть связанной с листом, поэтому проверяем на None.
            """
            print('Update color from Detail->Save')
            if self.printsheet:
                self.printsheet.update_colors()
            if self._loaded_values['printsheet_id']:
                old_sheet = PrintSheet.objects.get(id=self._loaded_values['printsheet_id'])
                old_sheet.update_colors()
```

