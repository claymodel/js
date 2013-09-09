console.log("hello world");

function say(word) {
	console.log(word);
}

function execute(functionName, value) {
	functionName(value);
}

execute(say, "Hello");
