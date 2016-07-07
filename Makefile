OCAMLOPT  = ocamlopt
OCAMLDEP  = ocamldep
OCAMLFIND = ocamlfind

# FILES
ROOT        = src
SOURCES     = $(shell $(OCAMLDEP) -native -sort $(FOLDERS_FLAG) \
	$(shell find $(ROOT) -name "*.ml"))
SOURCES_CMX = $(SOURCES:.ml=.cmx)
SOURCES_MLI = $(shell $(OCAMLDEP) -native -sort $(FOLDERS_FLAG) \
	$(shell find $(ROOT) -name "*.mli"))
SOURCES_CMI = $(SOURCES_MLI:.mli=.cmi)

# FLAGS
FOLDERS         = $(shell find $(ROOT) -type d)
FOLDERS_FLAG    = $(foreach folder,$(FOLDERS),-I $(folder))
WARNING_FLAGS   = -w @1..3@5..8@10..26@28..31+32..38@39..43@46..49+50
OCAMLC_FLAGS    = $(FOLDERS_FLAG) $(WARNING_FLAGS) -annot
PACKAGES        = cmdliner unix
PACKAGES_FLAGS  = $(foreach pkg,$(PACKAGES),-package $(pkg))
OCAMLFIND_FLAGS = $(PACKAGES_FLAGS) -linkpkg

BINARY = todo


.PHONY: all
all: depend $(SOURCES_CMI) $(SOURCES_CMX) $(BINARY)

$(BINARY): $(SOURCES_CMX)
	$(OCAMLFIND) $(OCAMLOPT) $(FOLDERS_OPT) $(OCAMLFIND_FLAGS) -o $@ $^


.PHONY: clean
clean:
	rm -f .depend $(BINARY)
	find $(ROOT) \( -name "*.cm*" -o -name "*.annot" -o -name "*.o" \) \
		-delete



# Default rules to compile every single ml[i] files.

.SUFFIXES: .ml .mli .cmi .cmx

.mli.cmi:
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLC_FLAGS) $(OCAMLFIND_FLAGS) -c $<

.ml.cmx:
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLC_FLAGS) $(OCAMLFIND_FLAGS) -c $<



# Dependency evaluation between ml[i] files.

.PHONY: depend
depend:
	$(OCAMLDEP) $(FOLDERS_FLAG) -native $(SOURCES_MLI) $(SOURCES) > .depend

-include .depend
