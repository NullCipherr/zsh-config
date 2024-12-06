# ========================
# Iniciar o Oh-My-Zsh
# ========================
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell" 
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh


# ========================
# Configurações de Prompt
# ========================
# Muda a cor do prompt
# autoload -U colors && colors
# PS1='%F{green}%n@%m%f:%F{blue}%~%f %# '  # Personaliza o prompt


# ========================
# Aliases 
# ========================
alias ll='ls -lah'             # ls com formato de listagem longa
alias gs='git status'          # git status
alias gc='git commit'          # git commit
alias gco='git checkout'       # git checkout
alias gl='git log'             # git log
alias ga='git add .'           # git add
alias ..='cd ..'               # Voltar um diretório
alias ...='cd ../..'           # Voltar dois diretórios
alias h='history'              # Histórico de comandos
alias j='jobs'                 # Ver jobs em segundo plano
alias c='clear'                # Limpa a tela


# ========================
# Habilitar o Autosuggestions
# ========================
# O plugin zsh-autosuggestions exibe sugestões enquanto digita
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=yellow"  # Cor da sugestão


# ========================
# Historico de Comandos
# ========================
HISTSIZE=1000             # Número de comandos no histórico
SAVEHIST=1000             # Número de comandos a salvar no arquivo de histórico
HISTFILE=~/.zsh_history   # Local do arquivo de histórico
setopt append_history     # Adiciona ao histórico, ao invés de sobrescrever
setopt hist_ignore_dups   # Ignora comandos duplicados no histórico
setopt hist_find_no_dups  # Ao buscar no histórico, não exibe duplicados


# ========================
# Melhorias
# ========================
# Evitar erro de "command not found" para comandos inválidos
setopt correct_all        # Corrige automaticamente comandos errados


# ========================
# Funções
# ========================
df-h () {
  # Exibe o espaço em disco de maneira amigável com ícones, cores e formatação aprimorada
  df -h --total | awk '
    NR==1 {
      # Cabeçalho em azul escuro e negrito
      print "\033[1;34m" $0 "\033[0m"
    }
    NR>1 {
      # Define as cores com base na porcentagem de uso
      use_percent = substr($5, 1, length($5)-1) + 0
      icon = (use_percent >= 90 ? "💥" : use_percent >= 50 ? "⚠️" : "✅")

      # Formata as linhas com ícones e cores
      if (use_percent >= 90) {
        print "\033[1;31m" icon " " $0 "\033[0m"  # Vermelho crítico
      } else if (use_percent >= 50) {
        print "\033[1;33m" icon " " $0 "\033[0m"  # Amarelo médio
      } else {
        print "\033[1;32m" icon " " $0 "\033[0m"  # Verde baixo
      }
    }
  '
}


ram-status () {
  # Exibe as informações de memória em uma tabela vertical
  free -h | awk '
    NR==1 {
      print "\033[1;34m" "--------------------------------------------------"
      print "               MEMORY USAGE REPORT               "
      print "--------------------------------------------------\033[0m"
    }
    NR==2 {
      # Armazenamento dos valores para uso posterior
      total=$2
      used=$3
      free=$4
      shared=$5
      buffers=$6
      cache=$7

      # Cálculos para determinar o percentual de uso
      used_percent = (used / total) * 100
      icon = (used_percent >= 90 ? "💥" : used_percent >= 50 ? "⚠️" : "✅")

      # Exibe as informações de memória de forma vertical
	  printf "\033[1;34m%-12s \033[0m%-10s\n", "TOTAL :>", $2
      printf "\033[1;34m%-12s \033[0m%-10s\n", "Used :>", $3
      printf "\033[1;34m%-12s \033[0m%-10s\n", "Free :>", $4
      printf "\033[1;34m%-12s \033[0m%-10s\n", "Shared :>", $5
      printf "\033[1;34m%-12s \033[0m%-10s\n", "Buffers :>", $6
      printf "\033[1;34m%-12s \033[0m%-10s\n", "Cache :>", $7

	  # Exibe o percentual de uso com ícone visual
      if (used_percent >= 90) {
        print "\033[1;31m" icon " Critical: " $3 " / " $2 " (" used_percent "%) \033[0m"
      } else if (used_percent >= 50) {
        print "\033[1;33m" icon " Moderate: " $3 " / " $2 " (" used_percent "%) \033[0m"
      } else {
        print "\033[1;32m" icon " Healthy: " $3 " / " $2 " (" used_percent "%) \033[0m"
      }

      print "--------------------------------------------------"
    }
  '
}


# Terminar automaticamente o Debian no WSL ao sair
trap 'wsl.exe --terminate Debian' EXIT
