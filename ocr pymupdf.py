import fitz  # PyMuPDF
import os

# CONFIGURAÇÕES
CAMINHO_PDF = "x.pdf"  # <--- COLOQUE O NOME DO SEU ARQUIVO AQUI
PASTA_SAIDA = "meus_recortes"
QUALIDADE = 3  # 3x de zoom (gera imagens nítidas para leitura)

def extrair_highlights():
    # Cria a pasta se não existir
    if not os.path.exists(PASTA_SAIDA):
        os.makedirs(PASTA_SAIDA)

    try:
        doc = fitz.open(CAMINHO_PDF)
    except Exception as e:
        print(f"Erro ao abrir PDF: {e}")
        return

    print(f"Processando {len(doc)} páginas...")
    total_extraido = 0

    for num_pag, pagina in enumerate(doc):
        anotacoes = pagina.annots()
        
        if not anotacoes:
            continue

        for i, anot in enumerate(anotacoes):
            # Tipo 8 é o Highlight (marca-texto) no padrão PDF
            if anot.type[0] == 8:
                try:
                    # Define a área do recorte (o retângulo do marca-texto)
                    rect = anot.rect
                    
                    # Adiciona uma pequena margem de 5 pixels para não cortar acentos
                    rect.x0 -= 5
                    rect.y0 -= 5
                    rect.x1 += 5
                    rect.y1 += 5

                    # Transforma a área em imagem com alta qualidade
                    mat = fitz.Matrix(QUALIDADE, QUALIDADE)
                    pix = pagina.get_pixmap(matrix=mat, clip=rect)

                    # Salva o arquivo
                    nome_arquivo = f"pag_{num_pag+1}_item_{i+1}.png"
                    pix.save(os.path.join(PASTA_SAIDA, nome_arquivo))
                    total_extraido += 1
                except Exception as e:
                    print(f"Erro na pág {num_pag+1}: {e}")

    doc.close()
    print(f"Pronto! {total_extraido} recortes salvos na pasta '{PASTA_SAIDA}'.")

if __name__ == "__main__":
    extrair_highlights()