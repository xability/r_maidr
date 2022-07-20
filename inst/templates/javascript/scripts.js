// It's important to add a load event listener to the object,
// as it will load the svg doc asynchronously
window.addEventListener("load", function () {

    const barplot = document.getElementById("barplot");
    // get the inner DOM of barplot.svg
    const svgDoc = barplot.contentDocument;

    // find svg element by tag name
    const svg = svgDoc.getElementsByTagName("svg")[0];
    //  and assign tabindex
    svg.setAttribute("tabindex", "0");
    // also application role for screen reader accessibility
    svg.setAttribute("role", "application");
    // Provide some informative announcement for the graph for screen reader
    svg.setAttribute("aria-label", "Press left and right arrow keys to navigate this graph.");


    // console.log(svgDoc)


    // select all bar elements
    let bar = svgDoc.querySelectorAll("g[id^='geom_rect.'] rect");
    // console.log(bar)
    let selectedCell = null;
    let pointer = 0;
    var audioElement = document.getElementById("theAudio");

    //Getting the height values from the Rect tag in the XML
    let ht = [];
    for (var i = 0; i < bar.length; i++) {
        ht.push(parseFloat(bar[i].getAttribute('height')));
        ht.sort(function (a, b) { return a - b });
    }
    console.log(ht);


    // bar[0].focus()
    bar[0].style.fill = '#FF9100'

    // add behaviour
    svgDoc.addEventListener('keydown', navigateGrid);
    document.addEventListener('keydown', navigateGrid);

    for (var i = 0; i < bar.length; i++) {
        bar[i].addEventListener('click', onClick);
    }

    function onClick(event) {
        updateSelectedCell(event.currentTarget);
        event.preventDefault();
    }

    function updateSelectedCell(cell) {
        audioElement.pause()
        audioElement.currentTime = 0;

        for (var i = 0; i < bar.length; i++) {
            bar[i].style.fill = '#595959';

            if (bar[i] == cell) {
                pointer = i;
            }

            audioElement.play()

            selectedCell = cell;
            selectedCell.style.fill = '#FF9100';
            // assign 
        }
    }

    function navigateGrid(event) {
        let newFocusedCell = null;
        switch (event.key) {
            case 'ArrowLeft':
                if (pointer == 0) {
                    break;
                }
                else if (pointer >= 1) {
                    pointer = pointer - 1;
                    newFocusedCell = bar[pointer];
                    break;
                }
            case 'ArrowRight':
                if (pointer < bar.length - 1) {
                    pointer = pointer + 1;
                    newFocusedCell = bar[pointer]
                }
        }
        if (newFocusedCell !== null) {
            updateSelectedCell(newFocusedCell);
        }
    }



    // const synth = window.speechSynthesis;
    // const utterance = new SpeechSynthesisUtterance('');
    // synth.speak(utterance);
    // processData();
    // // In Chrome, we need to wait for the "voiceschanged" event to be fired before we can get the list of all voices. See
    // //https://developer.mozilla.org/en-US/docs/Web/API/Web_Speech_API/Using_the_Web_Speech_API
    // // for more details
    // if (window.speechSynthesis.onvoiceschanged !== undefined) {
    //     window.speechSynthesis.onvoiceschanged = populateTtsList;
    // }

    // function getValues(variableName) {
    //     const url = new URL(window.location.href);
    //     const params = url.searchParams;
    //     if (params.has(variableName) === false) {
    //         return '';
    //     }
    //     return params.get(variableName);
    // }

    // function processData() {
    //     const container = document.getElementById('container');
    //     // const graphDescription = getUrlParam('description');
    //     // if (graphDescription !== '') {
    //     //     const graphDescriptionHeading = document.createElement('h1');
    //     //     graphDescriptionHeading.innerText = graphDescription;
    //     //     graphDescriptionHeading.setAttribute('tabindex', '0');
    //     //     container.appendChild(graphDescriptionHeading);
    //     //     graphDescriptionHeading.focus();
    //     // }
    //     // const warnDiv = document.createElement('div');
    //     // warnDiv.id = 'warningMessage';
    //     // container.appendChild(warnDiv);
    //     // parseData(getUrlParam('data'));
    //     createTtsCombo(container);
    //     // addReadEntireGraphButton(container);
    //     // addAudioConfigOptions(container);
    //     // const graphSummary = document.createElement('p');
    //     // graphSummary.innerText = getGraphSummary();
    //     // container.appendChild(graphSummary);
    //     // brailleController = new BrailleController(container, data);
    //     // brailleController.setSelectionListener(brailleControllerSelectionListener);
    //     // createGrid();
    //     addOnClickAndOnTouchSoundToGrid();
    //     // addNavigationToGrid();
    //     // const notificationDiv = document.createElement('div');
    //     // notificationDiv.id = 'notificationDiv';
    //     // notificationDiv.setAttribute('tabindex', '0');
    //     // container.appendChild(notificationDiv);
    //     // addLiveRegion(container);
    // }

    // function getFrequency(currentCell) {
    //     const MAX_FREQUENCY = 1000;
    //     const MIN_FREQUENCY = 100;
    //     const minValue = ht[0];
    //     const maxValue = ht[-1];
    //     let selectedValue = parseFloat(currentCell.firstChild.data);
    //     /**
    //      * Notice, when `selectedValue` is `NaN` the following `if` checks are `false`
    //      *         and when `selectedValue` is `NaN` then so too is `frequency`
    //      */
    //     if (selectedValue < minValue) {
    //         selectedValue = minValue;
    //     }
    //     if (selectedValue > maxValue) {
    //         selectedValue = maxValue;
    //     }
    //     let frequency = MIN_FREQUENCY;
    //     if (maxValue != minValue) {
    //         frequency += (selectedValue - minValue) / (maxValue - minValue) * (MAX_FREQUENCY - MIN_FREQUENCY);
    //     }
    //     return frequency;
    // }

}, false);
