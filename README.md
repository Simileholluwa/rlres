# RLRES (Red Light Running Enforcement System)

This project implements an AI-based Red Light Running Enforcement System (RLRES) with surveillance cameras, aiming to enhance road safety, induce behavioral change, improve law enforcement efficiency, gain data-driven insights, ensure cost-effectiveness, and boost public confidence. 

The system consists of three modules: a video streaming hub, video processing module, and system management module. It captures live video at red lights, identifies violating vehicles using a YOLO-trained model, extracts license plate numbers using Optical Character Recognition (OCR), and cross-references them with a database for citation issuance. 

It goes further to centralize the data on a cloud server, and offer streamlined administration through a Graphical User Interface (GUI) in a Flutter application. Experimental findings highlight impressive metrics, with a precision of 97.5% achieved by the YOLOv8n-trained model on unseen data. All YOLO-trained models demonstrated a consistent recall of 97.6%, while the YOLOv8s-trained model excelled with a remarkable mAP@50 of 96.8%. 

The results confirm that YOLO-based models are suitable for RLRES, offering valuable insights for selecting an optimal model that balances precision, recall, and computational efficiency in real-world scenarios. However, expanding the dataset could potentially pave way for smoother model performance and improved generalization.
