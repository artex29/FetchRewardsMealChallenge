//
//  MealRow.swift
//  FetchRewardsMealChallenge
//
//  Created by ANGEL RAMIREZ on 1/16/23.
//

import SwiftUI

struct MealRow: View {
    var meal: MealList
    @EnvironmentObject var model: ContentModel
    var body: some View {
        
        HStack(alignment: .bottom) {
            
            ZStack {
                
                let ImageUrl = URL(string: meal.strMealThumb)
                
                if model.getImageFromCache(mealName: meal.strMeal) == nil {
                    AsyncImage(url: ImageUrl) { phase in
                        
                        switch phase {
                            
                        case .empty:
                            // is loading the image
                            ProgressView()
                            
                        case .success(let image) :
                            
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .onAppear {
                                    
                                    model.saveToCache(image: image.asUIImage() , mealName: meal.strMeal)
                                }
                            
                        case .failure:
                            
                            Rectangle()
                                .foregroundColor(.gray)
                                .opacity(0.5)
                                .cornerRadius(10)
                            
                            
                        @unknown default:
                            Rectangle()
                                .foregroundColor(.gray)
                                .opacity(0.5)
                                .cornerRadius(10)
                        }
                        
                    }
                    .frame(height: 30)
                }
                else {
                    Image(uiImage: model.getImageFromCache(mealName: meal.strMeal)!)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .cornerRadius(10)
                }
                
                RoundedRectangle(cornerRadius: 5)
                    .stroke(style: .init(lineWidth: 2))
            }
            .frame(width: 30, height: 30)
            
            Text(meal.strMeal)
                .font(.headline)
                .fontWidth(.expanded)
            Spacer()
            
            
        }
        .padding(.vertical) 
        
    }
}

struct MealRow_Previews: PreviewProvider {
    static var previews: some View {
        MealRow(meal: MealList())
            .environmentObject(ContentModel())
    }
}

extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
