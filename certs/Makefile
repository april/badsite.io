# chain     :: pem <= []crt
# dhparam   :: pem <= int (#bits)
# gen-ca    :: crt <= conf, key
# gen-csr   :: csr <= conf, key
# gen-key    :: key <= int (#bits)
# gen-ecckey :: key <= string (ECC Prime)
# self-sign :: crt <= days, hash, extensions, conf, csr, key (self)
# sign      :: crt <= days, hash, extensions, conf, csr, key (CA), crt (CA)

# TODO:
# Generate the expired cert in the past.

# Note: Files and paths must not contain spaces.

D = badsite.io
MAIN_CERT_TYPE = rsa2048
DAYS_DEFAULT = 730
HASH_DEFAULT = sha256

SIGN_CA_DEFAULTS = 3650 $(HASH_DEFAULT) req_v3_ca
SIGN_LEAF_DEFAULTS = $(DAYS_DEFAULT) $(HASH_DEFAULT) req_v3_usr

# These variables will keep track of all chain targets.
CHAINS_PROD =
# These are chains that we can't get public versions of (usually due to Baseline Requirements).
CHAINS_LOCAL_ONLY =

O = sets/test

.PHONY: all
all: test

.PHONY: test
test: prod chains-local

.PHONY: prod
prod: chains-prod

.PHONY: clean
clean:
	rm -rf $(O)/gen

################################
$(O)/gen/key/ca-root.key:
	./tool gen-key $@ $(D) 4096
$(O)/gen/crt/ca-root.crt: src/conf/ca-root.conf $(O)/gen/key/ca-root.key
	./tool gen-ca $@ $(D) $^

################################
$(O)/gen/key/ca-intermediate.key:
	./tool gen-key $@ $(D) 4096
$(O)/gen/csr/ca-intermediate.csr: src/conf/ca-intermediate.conf $(O)/gen/key/ca-intermediate.key
	./tool gen-csr $@ $(D) $^
$(O)/gen/crt/ca-intermediate.crt: src/conf/ca-intermediate.conf $(O)/gen/csr/ca-intermediate.csr $(O)/gen/key/ca-root.key $(O)/gen/crt/ca-root.crt
	./tool sign $@ $(D) $(SIGN_CA_DEFAULTS) $^

################################
$(O)/gen/key/leaf-main.key: $(O)/gen/key/leaf-$(MAIN_CERT_TYPE).key
	cp $< $@
$(O)/gen/csr/wildcard-main.csr: $(O)/gen/csr/wildcard-$(MAIN_CERT_TYPE).csr
	cp $< $@
$(O)/gen/crt/wildcard-main.crt: $(O)/gen/crt/wildcard-$(MAIN_CERT_TYPE).crt
	cp $< $@

################################
$(O)/gen/csr/fallback.csr: src/conf/fallback.conf $(O)/gen/key/leaf-main.key
	./tool gen-csr $@ $(D) $^
$(O)/gen/crt/fallback.crt: src/conf/fallback.conf $(O)/gen/csr/fallback.csr $(O)/gen/key/ca-intermediate.key $(O)/gen/crt/ca-intermediate.crt
	./tool sign $@ $(D) $(SIGN_LEAF_DEFAULTS) $^
CHAINS_PROD += $(O)/gen/chain/fallback.pem
$(O)/gen/chain/fallback.pem: $(O)/gen/crt/fallback.crt
	./tool chain $@ $(D) $^

################################
$(O)/gen/key/leaf-rsa2048.key:
	./tool gen-key $@ $(D) 2048
$(O)/gen/csr/wildcard-rsa2048.csr: src/conf/wildcard.conf $(O)/gen/key/leaf-rsa2048.key
	./tool gen-csr $@ $(D) $^
$(O)/gen/crt/wildcard-rsa2048.crt: src/conf/wildcard.conf $(O)/gen/csr/wildcard-rsa2048.csr $(O)/gen/key/ca-intermediate.key $(O)/gen/crt/ca-intermediate.crt
	./tool sign $@ $(D) $(SIGN_LEAF_DEFAULTS) $^
CHAINS_PROD += $(O)/gen/chain/wildcard-rsa2048.pem
$(O)/gen/chain/wildcard-rsa2048.pem: $(O)/gen/crt/wildcard-rsa2048.crt $(O)/gen/crt/ca-intermediate.crt
	./tool chain $@ $(D) $^

################################
.PHONY: chains-prod
chains-prod: $(CHAINS_PROD)

.PHONY: chains-local
chains-local: chains-prod $(CHAINS_LOCAL_ONLY)

