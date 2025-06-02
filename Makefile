# install homebrew
# install swiftformat
# add pre-push hook
init:
	sh scripts/init.sh

# Reference : .swiftformat
format:
	swiftformat . --swiftversion 5
