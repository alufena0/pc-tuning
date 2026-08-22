import mammoth
import os
import sys

# CONFIGURAÇÕES
PASTA_ENTRADA = "."          # Pasta raiz a varrer (padrão: pasta atual)
PASTA_SAIDA   = "txt_saida"  # Onde os .txt serão salvos (None = mesmo lugar do .docx)
SOBRESCREVER  = False        # True = sobrescreve .txt já existentes

# ---------------------------------------------
# Troca PASTA_SAIDA por None para salvar cada
# .txt na mesma pasta do .docx original:
#   PASTA_SAIDA = None
# ---------------------------------------------

def converter_docx_para_txt(caminho_docx: str) -> str:
    """Extrai o texto puro de um .docx e retorna como string."""
    with open(caminho_docx, "rb") as f:
        resultado = mammoth.extract_raw_text(f)
    return resultado.value


def processar_pasta(pasta_entrada: str, pasta_saida: str | None, sobrescrever: bool):
    pasta_entrada = os.path.abspath(pasta_entrada)

    if pasta_saida:
        os.makedirs(pasta_saida, exist_ok=True)

    arquivos = [
        os.path.join(raiz, arquivo)
        for raiz, _, files in os.walk(pasta_entrada)
        for arquivo in files
        if arquivo.lower().endswith(".docx")
    ]

    if not arquivos:
        print("Nenhum arquivo .docx encontrado.")
        return

    print(f"Encontrados {len(arquivos)} arquivo(s) .docx. Convertendo...\n")
    convertidos = 0
    pulados    = 0
    erros      = 0

    for caminho_docx in arquivos:
        nome_base = os.path.splitext(os.path.basename(caminho_docx))[0]
        nome_txt  = nome_base + ".txt"

        if pasta_saida:
            # Recria a estrutura de subpastas dentro de pasta_saida
            rel       = os.path.relpath(os.path.dirname(caminho_docx), pasta_entrada)
            dest_dir  = os.path.join(pasta_saida, rel)
            os.makedirs(dest_dir, exist_ok=True)
            caminho_txt = os.path.join(dest_dir, nome_txt)
        else:
            caminho_txt = os.path.join(os.path.dirname(caminho_docx), nome_txt)

        if os.path.exists(caminho_txt) and not sobrescrever:
            print(f"  [PULADO]     {caminho_docx}  ?  já existe")
            pulados += 1
            continue

        try:
            texto = converter_docx_para_txt(caminho_docx)
            with open(caminho_txt, "w", encoding="utf-8") as f:
                f.write(texto)
            print(f"  [OK]         {caminho_docx}")
            print(f"               ? {caminho_txt}")
            convertidos += 1
        except Exception as e:
            print(f"  [ERRO]       {caminho_docx}")
            print(f"               {e}")
            erros += 1

    print(f"\nPronto!  Convertidos: {convertidos}  |  Pulados: {pulados}  |  Erros: {erros}")


if __name__ == "__main__":
    # Uso via linha de comando (opcional):
    #   python docx_para_txt.py [pasta_entrada] [pasta_saida]
    if len(sys.argv) >= 2:
        PASTA_ENTRADA = sys.argv[1]
    if len(sys.argv) >= 3:
        PASTA_SAIDA = sys.argv[2]

    processar_pasta(PASTA_ENTRADA, PASTA_SAIDA, SOBRESCREVER)