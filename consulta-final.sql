SELECT orders.order_id, orders.customer_id, orders.employee_id, orders.order_date,
    orders.required_date,
    orders.shipped_date,
    orders.ship_via,
    orders.freight,
    orders.ship_name,
    orders.ship_address,
    orders.ship_city,
    orders.ship_region,
    orders.ship_postal_code,
    orders.ship_country,
    orders_detail.product_id,
    orders_detail.unit_price,
    orders_detail.quantity,
    orders_detail.discount
	FROM
    orders INNER JOIN
    orders_detail ON orders.order_id = orders_detail.order_id;