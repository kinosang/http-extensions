LIBDIR := lib
DISABLE_RIBBON := true
INDEX_FORMAT := md


include $(LIBDIR)/main.mk

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update $(CLONE_ARGS) --init
else
	git clone -q --depth 10 $(CLONE_ARGS) \
	    -b main https://github.com/martinthomson/i-d-template $(LIBDIR)
endif

$(GHPAGES_EXTRA):
	ln -sf draft-ietf-httpbis-$@ $@

clean::
	-rm -f $(GHPAGES_EXTRA)

sf-rfc-validate ?= sf-rfc-validate.py
.PHONY: sf-lint
sf-lint: $(drafts_xml) sf-lint-install
	$(sf-rfc-validate) $(filter-out sf-lint-install,$^)

.PHONY: sf-lint-install
sf-lint-install:
	@hash sf-rfc-validate 2>/dev/null || pip3 install sf-rfc-validate
