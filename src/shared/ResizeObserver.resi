type dimensions = {width: int, height: int}

let useResizeObserver: React.ref<Nullable.t<Dom.element>> => option<dimensions>
