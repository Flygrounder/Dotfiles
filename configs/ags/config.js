function padWithZeroes(value, targetLength) {
	const stringValue = value.toString();
	const padding = "0".repeat(targetLength - stringValue.length);
	return `${padding}${stringValue}`;
}

const time = Variable(new Date(), {
	poll: [1000, () => new Date()],
});

const clock = Widget.Box({
	vertical: true,
	className: "clock__container",
	children: [
		Widget.Label({
			className: "clock__time",
			label: time.bind().as((value) => {
				return `${padWithZeroes(value.getHours(), 2)}:${padWithZeroes(value.getMinutes(), 2)}`;
			}),
		}),
		Widget.Label({
			className: "clock__date",
			label: time.bind().as((value) => {
				return `${padWithZeroes(value.getDate(), 2)}.${padWithZeroes(value.getMonth() + 1, 2)}.${value.getFullYear()}`;
			}),
		}),
	],
});

function divide([total, used]) {
	return used / total;
}

const cpu = Variable(0, {
	poll: [
		2000,
		"top -b -n 1",
		(out) =>
			divide([
				100,
				out
					.split("\n")
					.find((line) => line.includes("Cpu(s)"))
					.split(/\s+/)[1]
					.replace(",", "."),
			]),
	],
});

const ram = Variable(0, {
	poll: [
		2000,
		"free",
		(out) =>
			divide(
				out
					.split("\n")
					.find((line) => line.includes("Mem:"))
					.split(/\s+/)
					.splice(1, 2),
			),
	],
});

const swap = Variable(0, {
	poll: [
		2000,
		"free",
		(out) =>
			divide(
				out
					.split("\n")
					.find((line) => line.includes("Swap:"))
					.split(/\s+/)
					.splice(1, 2),
			),
	],
});

const disk = Variable(0, {
	poll: [
		2000,
		"df -h /",
		(out) =>
			parseInt(out.split("\n")[1].split(/\s+/)[4].replace("%", "")) / 100,
	],
});

function getMonitorWidget(label, value) {
	return Widget.Box({
		className: "monitor__container",
		child: Widget.CircularProgress({
			className: "monitor__circular",
			value,
			rounded: true,
			child: Widget.Label({
				label,
			}),
		}),
	});
}

const monitors = Widget.Box({
	children: [
		Widget.Box({
			spacing: 15,
			vertical: true,
			children: [
				Widget.Box({
					spacing: 15,
					children: [
						getMonitorWidget("CPU", cpu.bind()),
						getMonitorWidget("RAM", ram.bind()),
					],
				}),
				Widget.Box({
					spacing: 15,
					children: [
						getMonitorWidget("Disk", disk.bind()),
						getMonitorWidget("Swap", swap.bind()),
					],
				}),
			],
		}),
	],
});

const window = Widget.Window({
	layer: "background",
	name: "widgets",
	margins: [150, 100],
	anchor: ["right"],
	child: Widget.Box({
		vertical: true,
		css: "padding: 1px",
		children: [clock, monitors],
	}),
});

App.config({ windows: [window], style: "./style.css" });
