// go to https://app.pluralsight.com/library/history

function parseTime(string) {
    let time = 0;
	const arr = string.split(' ');
    arr.forEach(element => {
        if (element.endsWith('m')) {
			time += parseInt(element);
			return;
    	}
		if (element.endsWith('h')) {
			time += parseInt(element) * 60;
			return;
    	}
    });
	return time;
}

let totalTime = 0;

let list = document.getElementsByClassName('page---13fBP')[0].children[2].children;

for (let i = 1; i < list.length; i ++) {
	const text = list[i].children[3].firstChild.textContent;
    totalTime += parseTime(text);
}

console.log(`Total viewing time: ${Math.floor(totalTime / 60)}h ${totalTime % 60}m`);
