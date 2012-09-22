function flotable(data) {
    return _.map(stats.strength.buckets, function(a,b) { return [b, a] });
}

