FROM perl:latest
RUN curl -L https://cpanmin.us | perl - --sudo App::cpanminus
WORKDIR /app
COPY . /app
RUN cpanm --installdeps .
EXPOSE 3000
CMD ["morbo", "scipt/perl_Crud"]