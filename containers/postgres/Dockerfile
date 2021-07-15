FROM postgres:13.3
COPY pg.conf /etc/postgresql/postgresql.conf
COPY init.sql /docker-entrypoint-initdb.d/

# importing data using 'copy' command
COPY ./data/* /docker-entrypoint-initdb.d/

CMD ["-c", "config_file=/etc/postgresql/postgresql.conf"]