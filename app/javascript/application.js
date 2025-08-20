// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// Enhance all native date inputs so clicking anywhere in the field immediately opens the picker.
// Some browsers require clicking the calendar icon; this ensures a better UX.
const attachDatePickerAutoOpen = () => {
	document.querySelectorAll('input[type="date"]').forEach(input => {
		// Avoid double-binding
		if (input.dataset.autoPickerBound) return;
		input.dataset.autoPickerBound = 'true';

		const openPicker = () => {
			try {
				// showPicker is supported in modern Chromium / Safari 17+. Fallback is just focus.
				if (typeof input.showPicker === 'function') {
					input.showPicker();
				} else {
					input.focus();
				}
			} catch (e) {
				// Silent fail; focusing is enough.
				input.focus();
			}
		};

		// Open on first click inside the field
		input.addEventListener('click', openPicker);
		// Also open when it gains focus via keyboard navigation
		input.addEventListener('focus', openPicker);
		// Optional: pressing Enter triggers picker (some browsers just submit form otherwise)
		input.addEventListener('keydown', (e) => {
			if (e.key === 'Enter') {
				e.preventDefault();
				openPicker();
			}
		});
	});
};

document.addEventListener('turbo:load', attachDatePickerAutoOpen);
document.addEventListener('turbo:frame-load', attachDatePickerAutoOpen);

// Prevent inquiry button clicks from triggering the card link
const preventCardLinkOnButtonClick = () => {
	document.querySelectorAll('.car-book-btn').forEach(button => {
		if (button.dataset.clickHandlerBound) return;
		button.dataset.clickHandlerBound = 'true';

		button.addEventListener('click', (e) => {
			e.stopPropagation();
		});
	});

	document.querySelectorAll('.car-action-buttons').forEach(buttonContainer => {
		if (buttonContainer.dataset.clickHandlerBound) return;
		buttonContainer.dataset.clickHandlerBound = 'true';

		buttonContainer.addEventListener('click', (e) => {
			e.stopPropagation();
		});
	});
};

document.addEventListener('turbo:load', preventCardLinkOnButtonClick);
document.addEventListener('turbo:frame-load', preventCardLinkOnButtonClick);
