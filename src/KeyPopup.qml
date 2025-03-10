import QtQuick 2.12

/**
 * This is the key popup that shows a character preview above the
 * pressed key button like it is known from keyboards on phones.
 * Copyright 2015 Uwe Kindler
 * Licensed under MIT see LICENSE.MIT in project root
 */

Item {
    id: root
    property alias text: txt.text
    property alias font: txt.font

    property real widthFactor: 1.4
    property real heightFactor: 1.4

    width: 40
    height: 40
    visible: false

    Rectangle
    {
        id: popup
        anchors.fill: parent
        radius: Math.round(height / 30)
        z: shadow.z + 1

        gradient: Gradient
        {
                 GradientStop { position: 0.0; color: Qt.lighter(Qt.lighter("#35322f"))}
                 GradientStop { position: 1.0; color: Qt.lighter("#35322f")}

        }

        Text {
            id: txt
            color: "white"
            anchors.fill: parent
            fontSizeMode: Text.Fit
            font.pixelSize: height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Rectangle
    {
        id: shadow
        width: popup.width
        height: popup.height
        radius: popup.radius
        color: "#3F000000"
        x: 4
        y: 4
    }

    function popup(keybutton, inputPanel)
    {
        width = keybutton.width * root.widthFactor;
        height = keybutton.height * root.heightFactor;
        var KeyButtonGlobalLeft = keybutton.mapToItem(inputPanel, 0, 0).x;
        var KeyButtonGlobalTop = keybutton.mapToItem(inputPanel, 0, 0).y;
        var PopupGlobalLeft = KeyButtonGlobalLeft - (width - keybutton.width) / 2;
        var PopupGlobalTop = KeyButtonGlobalTop - height - pimpl.verticalSpacing * 1.5;
        var PopupLeft = root.parent.mapFromItem(inputPanel, PopupGlobalLeft, PopupGlobalTop).x;
        y = root.parent.mapFromItem(inputPanel, PopupGlobalLeft, PopupGlobalTop).y;
        if (PopupGlobalLeft < 0)
        {
            x = 0;
        }
        else if ((PopupGlobalLeft + width) > inputPanel.width)
        {
            x = PopupLeft - (PopupGlobalLeft + width - inputPanel.width);
        }
        else
        {
            x = PopupLeft;
        }

        text = keybutton.displayText;
        font.family = keybutton.font.family
        visible = Qt.binding(function() {return keybutton.isHighlighted});
    }
}


