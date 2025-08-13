# install homebrew
# install swiftformat
# add pre-push hook
init:
	sh scripts/init.sh

# Reference : .swiftformat
format:
	swiftformat . --swiftversion 5

# Read ios certificates
match-read:
	fastlane match development --readonly

# Update ios certificates
match-update:
	fastlane match development