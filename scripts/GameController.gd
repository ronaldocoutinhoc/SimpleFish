extends Node2D


static var fish1Cont = 0
static var fish2Cont = 0
static var fish3Cont = 0
static var fish4Cont = 0

static func increaseFishCont(fishIdentifier):
	if fishIdentifier == "fish1Cont":
		fish1Cont += 1
	if fishIdentifier == "fish2Cont":
		fish2Cont += 1
	if fishIdentifier == "fish3Cont":
		fish3Cont += 1
	if fishIdentifier == "fish4Cont":
		fish4Cont += 1

static func test():
	print("test")
