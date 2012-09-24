function flotable(data) {
    return _.map(data, function(a,b) { return [b, a]; });
}

function find_width(data) {
    var ks = Object.keys(data);
    return parseFloat(ks[1]) - parseFloat(ks[2]);
}

function make_distribution(canvas, data, color) {
    if(!color) color = "#FF7";
    $.plot($(canvas), [ {
        data: flotable(data.buckets),
        "color": color,
        bars: {
            show: true,
            barWidth: find_width(data.buckets)
        }
    } ]);
}
