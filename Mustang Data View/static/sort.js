function sortTable(columnIndex) {
    const table = document.querySelector("table");
    let switching = true;
    let direction = "asc";
    let switchCount = 0;

    while (switching) {
        switching = false;
        const rows = table.rows;

        // We'll track the row index where a switch should happen.
        let switchIndex = -1;
        for (let i = 1; i < rows.length - 1; i++) {
            let x = rows[i].getElementsByTagName("td")[columnIndex];
            let y = rows[i + 1].getElementsByTagName("td")[columnIndex];

            // If a cell is missing (e.g., header rows or malformed), skip
            if (!x || !y) continue;

            let xVal = x.innerText.trim().toLowerCase();
            let yVal = y.innerText.trim().toLowerCase();

            const xNum = parseFloat(xVal);
            const yNum = parseFloat(yVal);

            if (!isNaN(xNum) && !isNaN(yNum)) {
                if (direction === "asc" && xNum > yNum) { switchIndex = i; break; }
                if (direction === "desc" && xNum < yNum) { switchIndex = i; break; }
            } else {
                if (direction === "asc" && xVal > yVal) { switchIndex = i; break; }
                if (direction === "desc" && xVal < yVal) { switchIndex = i; break; }
            }
        }

        if (switchIndex !== -1) {
            // perform the swap of the two adjacent rows
            rows[switchIndex].parentNode.insertBefore(rows[switchIndex + 1], rows[switchIndex]);
            switching = true;
            switchCount++;
        } else {
            if (switchCount === 0 && direction === "asc") {
                direction = "desc";
                switching = true;
            }
        }
    }
}
