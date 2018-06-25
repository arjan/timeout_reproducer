FROM fedora:28

ENV LANG en_US.UTF-8
ADD config /var/reproducer/config/
ADD lib /var/reproducer/lib/ 
ADD mix.exs /var/reproducer/

RUN dnf install -y erlang git make

WORKDIR /var/elixir/
RUN git clone https://github.com/elixir-lang/elixir.git .
RUN make clean compile && \
    ln -s /var/elixir/bin/elixir /usr/bin/elixir && \
    ln -s /var/elixir/bin/elixirc /usr/bin/elixirc && \
    ln -s /var/elixir/bin/iex /usr/bin/iex && \
    ln -s /var/elixir/bin/mix /usr/bin/mix

WORKDIR /var/reproducer/

RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get

CMD iex -S mix
