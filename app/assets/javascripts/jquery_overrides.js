jQuery.expr.filters.hidden = function( elem ) {
    return ( elem.offsetWidth === 0 && elem.offsetHeight === 0 && elem.tagName != 'IMG') || (!jQuery.support.reliableHiddenOffsets && ((elem.style && elem.style.display) || curCSS( elem, "display" )) === "none");
};
