import Foundation

var boardData: [TaskList] = [
    TaskList(id: 0,
             title: "To do",
             tasks: [
                 Task(title: "Gray table footer with optional + Create button", tags: ["Afterburner"]),
                 Task(title: "Top header with the number of tasks", tags: ["Space jam"]),
                 Task(title: "Asset color catalog", tags: ["orange", "banana"]),
                 Task(title: "Asset color catalog", tags: ["orange", "banana"]),
                 Task(title: "Asset color catalog", tags: ["orange", "banana"]),
                 Task(title: "Asset color catalog", tags: ["orange", "banana"])
             ]),
    TaskList(id: 1,
             title: "In Progress",
             tasks: [
                 Task(title: "Main booster doesn’t fire on re-entry", tags: []),
                 Task(title: "Asset color catalog", tags: ["orange", "banana"])
             ]),
    TaskList(id: 2,
             title: "QA demo",
             tasks: [
                 Task(title: """
                     Therefore do not be anxious about tomorrow, for tomorrow will be anxious for itself. Let the day's own trouble be sufficient for the day.
                     """,
                      tags: ["bible"]),
                Task(title: "Engage Saturn shuttle", tags: ["rocket"])
             ])
]
