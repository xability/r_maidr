const audioContext = new (window['webkitAudioContext'] || window['AudioContext'])();
let synth = null;
let panner = null;
let source = null;

var audioElement = document.getElementById("theAudio");
// audioElement.addEventListener('progress',updateLoadingStatus,false);
// audioElement.addEventListener('canplaythrough',audioLoaded,false);
// audioElement.load();

// audioContext.play()

//Audio embedding
function getFrequency(currentCell) {
    const MAX_FREQUENCY = 1000;
    const MIN_FREQUENCY = 100;
    const minValue = parseFloat(getValues('minValue'));
    const maxValue = parseFloat(getValues('maxValue'));
    let selectedValue = parseFloat(currentCell.firstChild.data);
    /**
     * Notice, when `selectedValue` is `NaN` the following `if` checks are `false`
     *         and when `selectedValue` is `NaN` then so too is `frequency`
     */
    if (selectedValue < minValue) {
        selectedValue = minValue;
    }
    if (selectedValue > maxValue) {
        selectedValue = maxValue;
    }
    let frequency = MIN_FREQUENCY;
    if (maxValue != minValue) {
        frequency += (selectedValue - minValue) / (maxValue - minValue) * (MAX_FREQUENCY - MIN_FREQUENCY);
    }
    return frequency;
}
function playSoundWithSynthesizer() {
    setPanner(selectedCell);
    if (synth == null) {
        synth = new Tone.Synth();
    }
    if (synth.context.state == 'suspended') {
        synth.context.resume();
    }
    synth.connect(panner);
    panner.toDestination();
    synth.triggerAttackRelease(getFrequency(selectedCell), '8n');
}
function startSoundPlayback() {
    stopSoundPlayback();
    if (audioContext.state == 'suspended') {
        audioContext.resume();
    }
    if (getUrlParam('instrumentType') == 'synthesizer') {
        playSoundWithSynthesizer();
    }
    else {
        playSoundFromAudioFile();
    }
}
function playSoundWithSynthesizer() {
    setPanner(selectedCell);
    if (synth == null) {
        synth = new Tone.Synth();
    }
    if (synth.context.state == 'suspended') {
        synth.context.resume();
    }
    synth.connect(panner);
    panner.toDestination();
    synth.triggerAttackRelease(getFrequency(selectedCell), '8n');
}
function playSoundFromAudioFile() {
    const fileName = getFileToPlay(selectedCell);
    const request = new XMLHttpRequest();
    request.open('get', fileName, true);
    request.responseType = 'arraybuffer';
    request.onload = function () {
        const data = request.response;
        audioContext.decodeAudioData(data, playAudioFile);
    };
    request.send();
}
function onCellChange(event) {
    // Get the first changed touch point. We surely have one because we are listening to touchmove event, and surely a touch point have changed since the last event.
    const changedTouch = event.changedTouches[0];
    const elementUnderTouch = document.elementFromPoint(changedTouch.clientX, changedTouch.clientY);
    if (elementUnderTouch === selectedCell) {
        return;
    }
    if (elementUnderTouch === null || elementUnderTouch.getAttribute('role') !== 'gridcell') {
        return;
    }
    updateSelectedCell(elementUnderTouch);
    stopSoundPlayback();
    startSoundPlayback();
    event.stopPropagation();
}
function addOnClickAndOnTouchSoundToGrid() {
    document.querySelectorAll('[role="gridcell"]').forEach((element, _index) => {
        element.addEventListener('click', onClick);
        element.addEventListener('touchstart', startSoundPlayback);
        element.addEventListener('touchmove', onCellChange);
        element.addEventListener('touchleave', stopSoundPlayback);
        element.addEventListener('touchcancel', stopSoundPlayback);
    });
}
function getValues(variableName) {
    const url = new URL(window.location.href);
    const params = url.searchParams;
    if (params.has(variableName) === false) {
        return '';
    }
    return params.get(variableName);
}