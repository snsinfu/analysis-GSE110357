PRODUCTS = \
  data/processed/scRNAseq-GSE110357.csv

ARTIFACTS = \
  data/raw \
  data/processed


.PHONY: all clean

all: $(PRODUCTS)
	@:

clean:
	rm -rf $(ARTIFACTS)

# Rules for processing raw data for analysis.

data/processed/scRNAseq-GSE110357.csv: \
  data/raw/www.ncbi.nlm.nih.gov/geo/download/GSE110357_htseq_counts_all_v1.csv.gz \
  data/processed/Genes-Mus_musculus.csv
	scripts/resolve_gene_id $^ > $@

data/processed/Genes-Mus_musculus.csv: \
  data/raw/ftp.ensembl.org/pub/release-102/gtf/mus_musculus/Mus_musculus.GRCm38.102.chr.gtf.gz
	gzip -cd $< | scripts/gtfcut gene_id gene_name gene_biotype > $@

# Rules for downloading source data.

data/raw/www.ncbi.nlm.nih.gov/geo/download/%:
	curl --create-dirs -fsSLo '$@' "$$(scripts/geourl '$*')"

data/raw/ftp.ensembl.org/%:
	curl --create-dirs -fsSLo '$@' 'ftp://ftp.ensembl.org/$*'
