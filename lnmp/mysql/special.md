## Special

- 双字段组合重复

```html
SELECT 
  p1.* , GROUP_CONCAT(p1.`primary_key_field`)
FROM
  `field_b` p1 
GROUP BY CONCAT(
    p1.`field_a`,
    p1.`field_b`
  ) 
HAVING COUNT(
    CONCAT(
      p1.`field_a`,
      p1.`field_b`
    )
  ) > 1
```


