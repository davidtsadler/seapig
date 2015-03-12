NODE-BIN	= ./node_modules/.bin
APP		= ./app
TMP		= ./.tmp
XML		= ./xml
XSL		= ./xsl
CSS-SRC-PATH 	= $(APP)/css
DIST		= $(TMP)/dist
DOWNLOADS	= $(TMP)/downloads
TRANSFORMED	= $(TMP)/transformed
LOCALHOST	= $(TMP)/localhost

all:	clean build

build:	lint		\
	download	\
	transform

deploy: check_version 	\
	clean		\
	build		\
	dist		\
	minify
	@echo Site is ready for deployment with make s3.

s3:
	@find $(DIST) -type f \( -iname '*.xml' -or -iname '*.txt' -or -iname '*.css' -or -iname '*.js' -or -iname '*.html' \) -exec gzip "{}" \; -exec mv "{}.gz" "{}" \;
	@s3cmd sync --acl-public --exclude '*.*' --include '*.css' -m "text/css" --add-header="Cache-Control: max-age=604800" --add-header="Content-Encoding: gzip" --add-header="Vary: Accept-Encoding" $(DIST)/css/ s3://seapig.net/css/
	@s3cmd sync --acl-public --exclude '*.*' --include  '*.html' -m "text/html" --add-header="Cache-Control: max-age=604800, must-revalidate" --add-header="Content-Encoding: gzip" --add-header="Vary: Accept-Encoding" $(DIST)/ s3://seapig.net/
	@s3cmd sync --acl-public --exclude '*.*' --include  'sitemap.xml' -m "application/xml" --add-header="Cache-Control: max-age=604800, must-revalidate" --add-header="Content-Encoding: gzip" --add-header="Vary: Accept-Encoding" $(DIST)/ s3://seapig.net/
	@s3cmd sync --acl-public --exclude '*.*' --include 'robots.txt' -m "text/plain" --add-header="Cache-Control: max-age=6048000" --add-header="Content-Encoding: gzip" --add-header="Vary: Accept-Encoding" $(DIST)/ s3://seapig.net/
	s3cmd sync --acl-public --delete-removed  $(DIST)/ s3://seapig.net/

clean:
	@rm -rf $(DIST)
	@rm -rf $(TMP)

lint:
	@$(NODE-BIN)/csslint --quiet $(CSS-SRC-PATH)/*.css

download:
	@wget -q -i services -P $(DOWNLOADS)
	@echo "BulkDataExchange           : `sed -rn 's/.*<version>(.*)<\/version>/\1/p' $(DOWNLOADS)/BulkDataExchangeService.wsdl`"
	@echo "BusinessPoliciesManagement : `sed -rn 's/.*<version>(.*)<\/version>/\1/p' $(DOWNLOADS)/SellerProfilesManagementService.wsdl`"
	@echo "Feeback                    : `sed -rn 's/.*<Version>(.*)<\/Version>/\1/p' $(DOWNLOADS)/FeedbackService.wsdl`"
	@echo "FileTransfer               : `sed -rn 's/.*<Version>(.*)<\/Version>/\1/p' $(DOWNLOADS)/FileTransferService.wsdl`"
	@echo "Finding                    : `sed -rn 's/.*<Version>(.*)<\/Version>/\1/p' $(DOWNLOADS)/FindingService.wsdl`"
	@echo "HalfFinding                : `sed -rn 's/.*<Version>(.*)<\/Version>/\1/p' $(DOWNLOADS)/HalfFindingService.wsdl`"
	@echo "Merchandising              : `sed -rn 's/.*<Version>(.*)<\/Version>/\1/p' $(DOWNLOADS)/MerchandisingService.wsdl`"
	@echo "MerchantData               : `sed -rn 's/<!-- Version ([[:digit:]]{3}).*/\1/p' $(DOWNLOADS)/merchantdataservice.xsd`"
	@echo "Product                    : `sed -rn 's/.*<Version>(.*)<\/Version>/\1/p' $(DOWNLOADS)/ProductService.wsdl`"
	@echo "ProductMetadata            : `sed -rn 's/.*<version>(.*)<\/version>/\1/p' $(DOWNLOADS)/ProductMetadataService.wsdl`"
	@echo "Resolution Case Management : `sed -rn 's/.*<version>(.*)<\/version>/\1/p' $(DOWNLOADS)/ResolutionCaseManagementService.wsdl`"
	@echo "Return Management          : `sed -rn 's/.*<version>(.*)<\/version>/\1/p' $(DOWNLOADS)/ReturnManagementService.wsdl`"
	@echo "Shopping                   : `sed -rn 's/.*<Version>(.*)<\/Version>/\1/p' $(DOWNLOADS)/ShoppingService.wsdl`"
	@echo "Trading                    : `sed -rn 's/.*<Version>(.*)<\/Version>/\1/p' $(DOWNLOADS)/ebaySvc.wsdl`"

transform:
	@saxonb-xslt					\
		-ext:on					\
		-s:$(XML)/services.xml			\
		-xsl:$(XSL)/services.xsl		\
		destDirectory=$(TRANSFORMED)		\
	       	version=$(TAG)
	@saxonb-xslt					\
		-ext:on					\
		-s:$(XML)/services.xml			\
		-xsl:$(XSL)/call_reference.xsl		\
		wsdlDirectory=$(abspath $(DOWNLOADS))	\
		destDirectory=$(TRANSFORMED)		\
	       	version=$(TAG)
	@saxonb-xslt					\
		-ext:on					\
		-s:$(XML)/services.xml			\
		-xsl:$(XSL)/request_response.xsl	\
		wsdlDirectory=$(abspath $(DOWNLOADS))	\
		destDirectory=$(TRANSFORMED)		\
	       	version=$(TAG)
	@saxonb-xslt					\
		-ext:on					\
		-s:$(XML)/services.xml			\
		-xsl:$(XSL)/sitemap.xsl			\
		wsdlDirectory=$(abspath $(DOWNLOADS))	\
		destDirectory=$(TRANSFORMED)		\
	       	version=$(TAG)

dist:	$(DIST)
	@cp -r $(TRANSFORMED)/* $(DIST)
	@cp -r $(APP)/* $(DIST)

minify:	css-min html-min

css-min:
	@find $(DIST) -type f -iname "*.css" -exec $(NODE-BIN)/cleancss --output {} {} \;

html-min:
	@find $(DIST) -type f -iname "*.html" -exec $(NODE-BIN)/html-minifier --remove-comments --collapse-whitespace --output {} {} \;

localhost: $(LOCALHOST)
	@cp -r $(TRANSFORMED)/* $(LOCALHOST)
	@cp -r $(APP)/* $(LOCALHOST)

serve:
	@$(NODE-BIN)/http-server $(LOCALHOST)

$(DIST):
	@mkdir $(DIST)

$(LOCALHOST):
	@mkdir $(LOCALHOST)

# Ensures that the VERSION variable was passed to the make command
check_version:
	$(if $(VERSION),,$(error VERSION is not defined. Pass via "make deploy VERSION=4.2.1"))
