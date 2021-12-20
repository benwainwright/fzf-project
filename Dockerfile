FROM ubuntu:20.04
RUN apt-get update && apt-get install -y fzf git vim curl
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN mkdir -p ~/plugin
COPY . /root/plugin/
COPY .vimrc /root/
RUN mkdir -p ~/single-folder
RUN mkdir -p ~/repos/repo1
RUN mkdir -p ~/repos/repo2
RUN mkdir -p ~/repos/repo3
RUN git config --global user.email "bwainwright28@gmail.com"
RUN git config --global user.name "Ben Wainwright"
RUN cd ~/single-folder && git init && touch foo && git add foo && git commit -m "initial commit"
RUN cd ~/repos/repo1 && git init && touch foo && git add foo && git commit -m "initial commit"
RUN cd ~/repos/repo2 && git init && touch foo && git add foo && git commit -m "initial commit"
RUN cd ~/repos/repo3 && git init && touch foo && git add foo && git commit -m "initial commit"
RUN vim +PlugInstall +qall
