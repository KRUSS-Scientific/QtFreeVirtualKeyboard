import QtQuick 2.12
import QtQuick.Layouts 1.4
import "."
import "layouts"
import FreeVirtualKeyboard 1.0

/**
 * This is the QML input panel that provides the virtual keyboard UI
 * The code has been derived from
 * http://tolszak-dev.blogspot.de/2013/04/qplatforminputcontext-and-virtual.html
 * Copyright 2015 Uwe Kindler
 * Licensed under MIT see LICENSE.MIT in project root
 */
Item
{
    id: root
    objectName: "inputPanel"
    // width: parent.width
    // height: width / 4
    // Report actual keyboard rectangle to input engine
    onXChanged: InputEngine.setKeyboardRectangle(Qt.rect(x, y, width, height))
    onYChanged: InputEngine.setKeyboardRectangle(Qt.rect(x, y, width, height))
    onHeightChanged: InputEngine.setKeyboardRectangle(Qt.rect(x, y, width, height))
    onWidthChanged: InputEngine.setKeyboardRectangle(Qt.rect(x, y, width, height))

    property var model
    property color backgroundColor: "black"
    property real buttonWidth: -1

    property alias keypopupWidthFactor: keyPopup.widthFactor
    property alias keypopupHeightFactor: keyPopup.widthFactor

    signal enterPressed()

    function setCustomLayout(layout)
    {
        layoutSelector.setCustomLayout(layout);
    }

    function switchKeySetByImh(value)
    {
        layoutSelector.selectKeySetByImg(value);
    }

    property font font: Qt.font(
    {
        family: 'Helvetica',
        weight: Font.Normal,
        italic: false,
        pointSize: 12
    })

    LayoutSelector
    {
        id: layoutSelector
    }
    FontLoader
    {
        source: "FontAwesome.otf"
    }
    QtObject
    {
        id: pimpl
        property bool shiftModifier: false
        property int verticalSpacing: Math.round(keyboard.height / 40)
        property int horizontalSpacing: verticalSpacing - 3
        property int rowHeight: Math.round(keyboard.height/4 - verticalSpacing)
        property int buttonWidth: root.buttonWidth == -1 ? Math.round((keyboard.width - column.anchors.margins) / 10 - horizontalSpacing) - 2 : root.buttonWidth
    }

    Connections
    {
        target: root.model
        function onInputMethodHintsChanged(value)
        {
            layoutSelector.switchKeySetByImh(value);
        }
    }

    /**
     * This function shows the character preview popup for each key button
     */
    function showKeyPopup(keyButton)
    {
        keyPopup.popup(keyButton, root);
    }

    /**
     * The key popup for character preview
     */
    KeyPopup
    {
        id: keyPopup
        visible: false
        z: 100
    }


    Rectangle
    {
        id: keyboard
        color: root.backgroundColor
        anchors.fill: parent;

        MouseArea
        {
            anchors.fill: parent
        }

        Column
        {
            id: column
            anchors.margins: 5
            anchors.fill: parent
            spacing: pimpl.verticalSpacing

            Connections
            {
                target: layoutSelector
                function onCurrentLayoutChanged()
                {
                    rowsRepeater.model = layoutSelector.currentLayout.rows;
                }
            }

            Repeater
            {
                id: rowsRepeater
                width: parent.width

                delegate:
                RowLayout
                {
                    id: row
                    height: pimpl.rowHeight
                    spacing: pimpl.horizontalSpacing
                    anchors.horizontalCenter:parent.horizontalCenter
                    width: parent.width

                    Component.onCompleted:
                    {
                        pimpl.rowHeight = (root.height / layoutSelector.currentLayout.rows.count) - pimpl.verticalSpacing;
                    }

                    Repeater
                    {
                        model: keys

                        delegate:
                        KeySelector
                        {
                            id: keyButton
                            objectName: "keyButton_" + model.key
                            key: model.key
                            modeSwitchTarget: model.hasOwnProperty("modeSwitchTarget") && model.modeSwitchTarget ? model.modeSwitchTarget : ""
                            widthFactor: model.hasOwnProperty("widthFactor") && model.widthFactor > 0 ? model.widthFactor : -1
                            displayText: model.hasOwnProperty("displayText") && model.displayText ? model.displayText : ""

                            Connections
                            {
                                target: keyButton
                                function onSwitchToKeySet(value)
                                {
                                    keyPopup.visible = false;
                                    layoutSelector.switchKeySet(value);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
