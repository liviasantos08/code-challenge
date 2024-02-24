FROM openjdk:8-alpine

WORKDIR /root

WORKDIR /app

RUN apk update

FROM openjdk:11-jdk


# Install Embulk
RUN mkdir /embulk
RUN curl --create-dirs -o /embulk/embulk.jar -L "https://github.com/embulk/embulk/releases/download/v0.11.2/embulk-0.11.2.jar"
RUN curl --create-dirs -o "/embulk/jruby-complete-9.4.5.0.jar" -L "https://repo1.maven.org/maven2/org/jruby/jruby-complete/9.4.5.0/jruby-complete-9.4.5.0.jar"

# Config Embulk
RUN mkdir /root/.embulk
RUN echo "jruby=file:///embulk/jruby-complete-9.4.5.0.jar" > /root/.embulk/embulk.properties

# Install Embulk plugins
RUN java -jar /embulk/embulk.jar gem install liquid
RUN java -jar /embulk/embulk.jar gem install embulk -v 0.11.2
RUN java -jar /embulk/embulk.jar gem install msgpack -v 1.7.2
RUN java -jar /embulk/embulk.jar gem install embulk-input-postgresql
RUN java -jar /embulk/embulk.jar gem install embulk-output-postgresql
RUN java -jar /embulk/embulk.jar gem install embulk-input-ftp
RUN java -jar /embulk/embulk.jar gem install embulk-output-ftp

RUN mkdir -p /input \
    /output \
    /data/postgres/territories \
    /data/postgres/categories \
    /data/postgres/customer \
    /data/postgres/customer_customer_demo \
    /data/postgres/customer_demographics \
    /data/postgres/employee_territories \
    /data/postgres/employees \
    /data/postgres/orders \
    /data/postgres/products \
    /data/postgres/region \
    /data/postgres/shippers \
    /data/postgres/suppliers \
    /data/postgres/us_states \
    /data/postgres/order_details

# Copy data csv
COPY data/order_details.csv /data/postgres/order_details

# Copy configuration files input
COPY files/input/territories.yml /input/
COPY files/input/categories.yml /input/
COPY files/input/customer.yml /input/
COPY files/input/customer_customer_demo.yml /input/
COPY files/input/customer_demographics.yml /input/
COPY files/input/employee_territories.yml /input/
COPY files/input/employees.yml /input/
COPY files/input/orders.yml /input/
COPY files/input/order_details.yml /input/
COPY files/input/products.yml /input/
COPY files/input/region.yml /input/
COPY files/input/shippers.yml /input/
COPY files/input/suppliers.yml /input/
COPY files/input/us_states.yml /input/


# Copy configuration files output
COPY files/output/territories-out.yml /output/
COPY files/output/categories-out.yml /output/
COPY files/output/customer-out.yml /output/
COPY files/output/customer_customer_demo-out.yml /output/
COPY files/output/customer_demographics-out.yml /output/
COPY files/output/employee_territories-out.yml /output/
COPY files/output/employees-out.yml /output/
COPY files/output/orders-out.yml /output/
COPY files/output/products-out.yml /output/
COPY files/output/region-out.yml /output/
COPY files/output/shippers-out.yml /output/
COPY files/output/suppliers-out.yml /output/
COPY files/output/us_states-out.yml /output/
COPY files/output/order_details-out.yml /output/