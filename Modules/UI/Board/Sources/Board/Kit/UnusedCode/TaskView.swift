
import SwiftUI

//#if DEBUG
//struct TaskView_Previews: PreviewProvider {
//    static let task = Task(title: "Flight controller doesn’t handle multiple requests", tags: ["Launch platform"])
//    static var previews: some View {
//        Group {
//            TaskView(task)
//                .environment(\.colorScheme, .dark)
//                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
//                .previewDisplayName("iPhone SE")
//        }
//   }
//}
//#endif

struct TaskView: View
{
    private let task: Task
    private let margin = CGFloat(10)
    private let width = CGFloat(190) // <--- width of the cell

    private let titleFontSize = CGFloat(14)
    private var titleFont: UIFont { UIFont.systemFont(ofSize: titleFontSize) }
    private var titleHeight: CGFloat { StringDimension.heightUsingBoundingRect(for: task.title, font: titleFont, width: width) }

    private let tagFontSize = CGFloat(12)
    private var tagFont: UIFont { UIFont.systemFont(ofSize: titleFontSize) }
    private var tagHeight: CGFloat { StringDimension.heightUsingBoundingRect(for: task.title, font: titleFont, width: width) }
    private var tagMargin = CGFloat(2)

    var body: some View
    {
        //swiftlint:disable:next closure_body_length
        ZStack {
            Spacer() // minLength: 160
                .background(Color.blue)
                .cornerRadius(CGFloat(12))

            //swiftlint:disable:next closure_body_length
            VStack(alignment: .leading, spacing: 10) {

                Text(task.title)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .font(Font.system(size: titleFontSize))
                    .frame(width: width, height: titleHeight, alignment: .leading)
                    .background(Color.red)

                // WrapStack(strings: task.tags)

                HStack {
                    ForEach(task.tags, id: \.self) {

                        Text("\($0)")
                            .lineLimit(1)
                            .font(Font.system(size: self.tagFontSize))
                            .foregroundColor(.black)
                            .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                            .background(Color.yellow)
                            .cornerRadius(CGFloat(4))
                            .multilineTextAlignment(.leading)
                    }
                }
                HStack {

                    Image(systemName: "cloud.heavyrain.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: CGFloat(14))
                        .foregroundColor(Color.white)

                    Text("TRS-18")
                        .font(Font.system(size: self.tagFontSize))
                        .foregroundColor(.white)
                        .padding(.leading, -3)

                    // swiftlint:disable:next force_unwrapping
                    Image(uiImage: UIImage(named: "sofia", in: Bundle.main, with: nil)!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: CGFloat(20), height: CGFloat(20))
                        .clipShape(Circle())
                        .cornerRadius(CGFloat(10))
                        .padding(.leading, 80) // cheating, I still don’t know how to position this, zstack?
                }
            }
            .padding(EdgeInsets(top: margin, leading: margin, bottom: margin, trailing: margin))
        }
    }

    init(_ task: Task)
    {
        self.task = task
    }
}
