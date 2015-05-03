var CF = {};

var lastCallArgs = {
    'getJoin': [],
    'getJoins': [],
    'setJoin': [],
    'setJoins': [],
    'setToken': [],
    'addTag': [],
    'addTags': [],
    'removeTag': [],
    'getProperties': []
};
CF.lastCallArgs = lastCallArgs;

var joinValues = {
    //defined join
    'd1': {
        join: 'd1',
        value: 1,
        tokens: {
            '[join]': 'd1'
        },
        tags: ['d1']
    },
    //undefined join
    'd2': {
        join: 'd2',
        value: null,
        tokens: {},
        tags: undefined
    }
};

var joinProperties = {
    'd1': {
        join: 'd1',
        x: 0,
        y: 50,
        width: 320,
        height: 100,
        xRotation: 90,
        yRotation: 180,
        zRotation: 270,
        scale: 1.1,
        opacity: 0.5,
        theme: 'test_theme'
    },
    'd2': {
        join: 'd2',
        x: 100,
        y: 51,
        width: 321,
        height: 101,
        xRotation: 91,
        yRotation: 181,
        zRotation: 271,
        scale: 1.0,
        opacity: 1.0,
        theme: 'test_theme2'
    }
};

function getJoin(join, callback) {
    CF.lastCallArgs.getJoin = arguments;
    setTimeout(function() {
        var value = null;
        var tokens = {};
        var tags = undefined;

        var joinValue = joinValues[join];
        if (joinValue && joinValue.value) {
            value = joinValue.value
        }
        if (joinValue && joinValue.tokens) {
            tokens = joinValue.tokens;
        }
        if (joinValue && joinValue.tags) {
            tags = joinValue.tags;
        }

        callback(join, value, tokens, tags);
    }, 0);
}
CF.getJoin = getJoin;

function getJoins(joins, callback) {
    CF.lastCallArgs.getJoins = arguments;
    setTimeout(function() {
        var returnJoins = {};
        for (var joinIdx in joins) {
            var joinString = joins[joinIdx];
            var joinValue = joinValues[joinString];
            if (joinValue && joinValue.value !== null) {

                returnJoins[joinString] = joinValue;
            }
        }
        callback(returnJoins);
    }, 0);
}
CF.getJoins = getJoins;

function setJoin(join, value, sendJoinChangeEvent) {
    CF.lastCallArgs.setJoin = arguments;
    //clear out the join values
    CF.joins = {};

    CF.joins[join] = {
        value: value,
        sentJoinChangeEvent: sendJoinChangeEvent
    };
}
CF.setJoin = setJoin;

function setJoins() {
    CF.lastCallArgs.setJoins = arguments;
}
CF.setJoins = setJoins;

function setToken() {
    CF.lastCallArgs.setToken = arguments;
}
CF.setToken = setToken;

function addTag() {
    CF.lastCallArgs.addTag = arguments;
}
CF.addTag = addTag;

function addTags() {
    CF.lastCallArgs.addTags = arguments;
}
CF.addTags = addTags;

function removeTag() {
    CF.lastCallArgs.removeTag = arguments;
}
CF.removeTag = removeTag;

function getProperties() {
    CF.lastCallArgs.getProperties = arguments;

    var joins = arguments[0];
    var callback = arguments[1];

    setTimeout(function() {
        if (joins.length > 1) {
            callback([joinProperties['d1'], joinProperties['d2']]);
        } else {
            callback([joinProperties['d1']]);
        }
    }, 0);
}
CF.getProperties = getProperties;

function setProperties() {
    CF.lastCallArgs = arguments;
    var changes = arguments[0];
}
CF.setProperties = setProperties;